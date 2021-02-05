/*
MIT License

Copyright (c) 2017 Matt Addy

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/
@isTest
private class sfab_ParentRelationshipNodeTest {
    @isTest
    private static void build_expectSerializeInvokedOnParent() {
        sfab_FabricatedSObjectStub fabricatedParent = new sfab_FabricatedSObjectStub(Account.class);
        sfab_ParentRelationshipNode node = new sfab_ParentRelationshipNode('Account__r', fabricatedParent);

        node.serialize();

        System.assert(fabricatedParent.serializeInvoked);
    }

    @isTest
    private static void build_expectSerializedParentMap() {
        sfab_FabricatedSObjectStub fabricatedParent = new sfab_FabricatedSObjectStub(Account.class, new Map<String, Object> { 'Name' => 'Foo' });
        sfab_ParentRelationshipNode node = new sfab_ParentRelationshipNode('Account__r', fabricatedParent);

        Map<String, Object> builtNode = node.serialize();

        System.assertEquals(new Map<String, Object> { 'Account__r' => fabricatedParent.serialize() }, builtNode);
    }
}